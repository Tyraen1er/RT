/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noise.cl                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 16:25:06 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/09 15:03:03 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"
#include "rand.cl"

static unsigned int		ft_perlin(unsigned int i, const double x, const double y, const double z)
{
	const int		j = i & 0xff;
	const int3		grad[16] = {
		{1, 1, 0}, \
		{1, -1, 0}, \
		{-1, 1, 0}, \
		{-1, -1, 0}, \
		{1, 0, 1}, \
		{1, 0, -1}, \
		{-1, 0, 1}, \
		{-1, 0, -1}, \
		{0, 1, 1}, \
		{0, 1, -1}, \
		{0, -1, 1}, \
		{0, -1, -1}, \
		{1, 1, 0}, \
		{-1, 1, 0}, \
		{0, -1, 1}, \
		{0, -1, -1}
	};

	return ((x * grad[j % 16].x) + (y * grad[j % 16].y) + (z * grad[j % 16].z));
}

static double			ft_noise_weight(const double w)
{
	return ((w * w * w * (w * (w * 6 - 15) + 10)));
}

static double			ft_interp(const double w, const double n1, const double n2)
{
	return (n1 + w * (n2 - n1));
}

static double			ft_noise(const t_noise *noise, const t_vector hit, __constant double *rand)
{
	const t_vector	v1 = floor(hit);
	const t_vector	v2 = hit - v1;
	const t_vector	v3 = v2 - 1.0;
	const int3		u1 = {
		(int)v1.x, \
		(int)v1.y, \
		(int)v1.z
	};
	const int3		u2 = u1 + 1;

	const unsigned int	p1 = (int)fabs(rand[(u1.x & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p2 = (int)fabs(rand[(u2.x & 0xff) % MAX_RAND]) % 256;

	const unsigned int	p3 = (int)fabs(rand[((u1.y + p1) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p4 = (int)fabs(rand[((u2.y + p1) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p5 = (int)fabs(rand[((u1.y + p2) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p6 = (int)fabs(rand[((u2.y + p2) & 0xff) % MAX_RAND]) % 256;
	
	const unsigned int	p7 = (int)fabs(rand[((u1.z + p3) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p8 = (int)fabs(rand[((u1.z + p4) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p9 = (int)fabs(rand[((u1.z + p5) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p10 = (int)fabs(rand[((u1.z + p6) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p11 = (int)fabs(rand[((u2.z + p3) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p12 = (int)fabs(rand[((u2.z + p4) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p13 = (int)fabs(rand[((u2.z + p5) & 0xff) % MAX_RAND]) % 256;
	const unsigned int	p14 = (int)fabs(rand[((u2.z + p6) & 0xff) % MAX_RAND]) % 256;

	const int3			v4 = {
		ft_perlin(p7, v2.x, v2.y, v2.z), \
		ft_perlin(p8, v3.x, v2.y, v2.z), \
		ft_perlin(p9, v2.x, v3.y, v2.z)
	};
	const int3			v5 = {
		ft_perlin(p10, v3.x, v3.y, v2.z), \
		ft_perlin(p11, v2.x, v2.y, v3.z), \
		ft_perlin(p12, v3.x, v2.y, v3.z)
	};
	const int2			v6 = {
		ft_perlin(p13, v2.x, v3.y, v3.z), \
		ft_perlin(p14, v3.x, v3.y, v3.z)
	};
	const t_vector		w = {
		ft_noise_weight(v2.x), \
		ft_noise_weight(v2.y), \
		ft_noise_weight(v2.z)
	};
	
	return (ft_interp(w.x, \
				ft_interp(w.y, \
					ft_interp(w.x, v4.x, v4.y), \
					ft_interp(w.x, v4.z, v5.x)), \
				ft_interp(w.y, \
					ft_interp(w.x, v5.y, v5.z), \
					ft_interp(w.x, v6.x, v6.y) \
					) \
				) \
			);
}

static double			ft_perlin_noise(const __global t_object *obj, const t_vector hit, __constant double *rand)
{
	t_noise	n2 = obj->noise;
	double	noise;
	int		i;

	noise = 0.0;
	n2.intensity = ((n2.intensity < 1) ? 1.0 : n2.intensity);
	i = -1;
	while (++i < obj->noise.oct)
	{
		noise += ft_noise(&n2, hit * n2.freq, rand) * n2.intensity;
		n2.intensity /= n2.persis;
		n2.freq *= 2.0;
	}
	return(noise);
}

/*
	static	int				ft_perlin2(const int a, const int b)
	{
		int		w = a + b * 57;
		
		w = (w << 13) ^ w;
		return (1.0 - ((w * w * (w * (w * w * 15731) + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
	}

	static double			ft_noise_weight2(const int a, const int b)
	{
		const double	n1 = (ft_perlin2(a, b) + ft_perlin2(a + 1, b) + ft_perlin2(a, b + 1) + ft_perlin2(a + 1, b + 1)) / 16.0;
		const double	n2 = (ft_perlin2(a, b) + ft_perlin2(a + 1, b) + ft_perlin2(a, b + 1)) / 8.0;
		const double	n3 = ft_perlin2(a, b) / 4.0;

		return (n1 + n2 + n3);
	}

	static double			ft_interp2(double a, double b, double c)
	{
		return ((a * (1 - (1 - cos(c * M_PI)) * .5) + b * c));
	}

	static double			ft_noise2(const t_noise noise, const t_vector hit, __constant double *rand)
	{
		const int2		i1 = {
			(int)hit.x,\
			(int)hit.y
		};
		const double2	d1 = {
			hit.x - i1.x, \
			hit.y - i1.y
		};
		const double4	d2 = {
			ft_noise_weight2(i1.x, i1.y),\
			ft_noise_weight2(i1.x, i1.y + 1),\
			ft_noise_weight2(i1.x + 1, i1.y),\
			ft_noise_weight2(i1.x + 1, i1.y + 1)
		};
		const double2	d3 = 
		{
			ft_interp2(d2.x, d2.y, d1.x), \
			ft_interp2(d2.z, d2.w, d1.y)
		};

		return (ft_interp2(d3.x, d3.y, d1.y));
	}

	static double			ft_perlin_noise2(const __global t_object *obj, const t_vector hit, __constant double *rand)
	{
		t_noise		noise = obj->noise;
		double		value = 0.0;
		int			i = -1;

		while (++i != noise.oct)
		{
			value += ft_noise2(noise, hit, rand);
			if (value != 0)
				printf("%f\n", value);
			noise.freq *= 2.0;
			noise.intensity *= obj->noise.intensity;
		}
		return (value);
	}
*/
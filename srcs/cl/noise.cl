/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   noise.cl                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 16:25:06 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/05 15:56:24 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"
#include "rand.cl"

static double	ft_rand(const int x)
{
	int		n;

	n = (x << 13) ^ t;
	n = (n * (n * n * 15731 + 789221) + 1376312589);
	return ((n & 0x7fffffff) / 1073741824.0);
}

static double	ft_noise(const double a, const double b, const double c)
{
	double	d;

	d = 1 - cos(c * M_PI) * 0.5;
	d = 
}

static double	ft_perlin_noise(__global t_rt *rt, const t_vector n, \
									__constant double *rand, const t_vector hit)
{
	const int2		xy = {
		.x = ((int)hit.x < 0) ? (int)hit.x - 1 : (int)hit.x, \
		.y = ((int)hit.x < 0) ? (int)hit.x - 1 : (int)hit.x
	};
	const double2	yx = {
		.x = hit.x - xy.x, \
		.y = 0
	};
	const double	n = ft_rand(xy.x);
	const double	n2 = ft_rand(xy.x + xy.y);

	return (ft_noise());
}
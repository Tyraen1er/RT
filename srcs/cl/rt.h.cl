/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rt.h.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/16 19:13:34 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/08 20:00:04 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef RT_H_CL
# define RT_H_CL

# define GLOBAL_X		1
# define GLOBAL_Y		0
# define WIN_H			800
# define WIN_W			1200

# define MAX_BOUNCES	100
# define PI				3.141596
# define MAX_RAND		5000
# define OBJS_MAX		50
# define LGTS_MAX		15

# define SPHERE			0
# define PLANE			1
# define CONE			2
# define CYLINDER		3

# define CHESSBOARD 	1
# define BRICKS 		2
# define WOOD 			3
# define MARBLE 		4
# define PERLIN 		5

# define BRICK_W		0.5
# define BRICK_H		0.1
# define MORTAR_W		0.015
# define MORTAR_H		0.0075
# define CHESS_SIZE		0.01

typedef double3		t_vector;

typedef struct		s_yx
{
	int				y;
	int				x;
}					t_yx;

typedef struct		s_color
{
	int				r;
	int				g;
	int				b;
	int				c;
}					t_color;

typedef struct		s_shader
{
	double3			c1;
	double3			c2;
	double3			c3;
}					t_shader;

typedef struct		s_equation
{
	double			a;
	double			b;
	double			c;
	double			delta;
}					t_equation;

typedef struct		s_ray
{
	t_vector		n;
	t_vector		pos;
	t_vector		dir;
	double			t;
	double			dist;
	double			otherside;
	int				id;
	int				bounces;
}					t_ray;

typedef struct		s_light
{
	t_vector		pos;
	double			intensity;
}					t_light;

typedef struct		s_noise
{
	int				oct;
	double			freq;
	double			persis;
	double			intensity;
}					t_noise;

typedef struct		s_object
{
	t_vector		pos;
	t_vector		rot;
	t_vector		size;
	t_noise			noise;
	t_color			color;
	double			reflect;
	double			refract;
	double			transp;
	double			spec;
	double			np;
	int				negative;
	int				type;
	int				p_texture;
}					t_object;

typedef struct		s_eye
{
	t_vector		pos;
	t_vector		rot;
	double			fov;
	double			zoom;
	double			aspect;
}					t_eye;

typedef struct		s_key
{
	int			w;
	int			s;
	int			d;
	int			a;
	int			space;
	int			lctrl;
	int			q;
	int			e;
}					t_key;

typedef struct		s_rt
{
	t_object		objects[OBJS_MAX];
	t_light			lights[LGTS_MAX];
	t_eye			eye;
	t_vector		m[3];
	int				nb_obj;
	int				nb_light;
	int				shadows;
	int				line;
	int				effects;
}					t_rt;

static void 			 check_col_neg(__global t_rt *rt, t_ray *ray, int hit);
void print_data_infos(__global t_rt *rt, const t_yx coords, t_ray ray);
static unsigned int		ft_perlin(unsigned int i, const double x, const double y, const double z);
static unsigned int		ft_rand(const unsigned int x);
static unsigned int		ft_rand2(const unsigned int x, const unsigned int y);
static unsigned int		ft_rand3(const unsigned int x, const unsigned int y, const unsigned int z);
static t_vector			ft_normale(__global t_rt *rt, __global t_object *obj, const t_vector hit, const t_ray *ray, __constant double *rand);
static double			ft_calc_light(__global t_rt *rt, __global t_object *obj, __global t_light *l, const t_ray *ray, __constant double *rand);
static void				ft_check_collisions_2(__global t_rt *rt, __global t_light *l, t_ray *ray);
static void				ft_sphere_col(const t_object obj, t_ray *ray);
static void				ft_plane_col(const t_object obj, t_ray *ray);
static void				ft_cone_col(const t_object obj, t_ray *ray);
static void				ft_cyl_col(const t_object obj, t_ray *ray);
static double			ft_shadow_col(t_rt *tmp, t_ray *r);
static double			ft_hard_shadows(__global t_rt *rt, const t_vector hit, __global t_light *light);
static double			ft_soft_shadows(__global t_rt *rt, const t_vector hit, __global t_light *light, __constant double *rand);
static void				ft_reflect_ray(__global t_rt *rt, t_ray *ray, __constant double *rand);
static void				ft_refract_ray(t_ray *ray, const double n1, const double n2, const t_vector n);
static t_color			ft_procedural_texture(__global t_rt *rt, t_ray ray, __global t_object *obj, __constant double *rand);
static t_color			ft_bricks(double2 coords, __constant double *rand, __global const t_object *obj);
static t_color			ft_marble(const t_vector hit, const __global t_object *obj, const t_vector n, __constant double *rand);
static t_color			ft_wood(const t_vector hit, const __global t_object *obj, const t_vector n, __constant double *rand);
static double			ft_perlin_noise(const __global t_object *obj, const t_vector hit, __constant double *rand);
static double2			ft_get_text_coords(const t_vector hit, __global t_object *obj, const t_ray *ray, __constant double *rand, __global t_rt *rt);
static double2			ft_sphere_text_coords(const t_vector hit, const __global t_object *obj);
static double2			ft_cone_text_coords(const t_vector hit, const __global t_object *obj);
static double2			ft_cyl_text_coords(const t_vector hit, const __global t_object *obj, const t_ray *ray);
static double2			ft_plane_text_coords(const t_vector hit, const __global t_object *obj);
static t_color			ft_color(__global t_rt *rt, const t_ray ray, const double l, __constant double *rand);
static t_color			ft_ref_color(__global t_rt *rt, t_ray *ray, const double ref, __constant double *rand);
static t_color			ft_refract_color(__global t_rt *rt, const double n1, const double n2, t_ray *ray);
static t_color			ft_reflection(__global t_rt *rt, t_ray *ray, __constant double *rand);
static t_color			ft_transp_color(__global t_rt *rt, t_ray *ray, __constant double *rand);
static t_color			ft_transparency(__global t_rt *rt, const double transp, t_ray *ray, __constant double *rand);
static t_vector			ft_proc_perturb(__global t_rt *rt, t_vector n, __global t_object *obj, __constant double *rand, const t_vector hit, const t_ray *ray);
static t_vector			ft_bricks_pert(const double2 coords, __constant double *rand);
static t_vector			ft_perturbation(__global t_rt *rt, t_vector n, __global t_object *obj, __constant double *rand, const t_vector hit, const t_ray *ray);

#endif

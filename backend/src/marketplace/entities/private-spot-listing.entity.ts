import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('private_spot_listings')
export class PrivateSpotListing {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  ownerUserId!: string;

  @Column()
  title!: string;

  @Column({ type: 'float' })
  lat!: number;

  @Column({ type: 'float' })
  lng!: number;

  @Column({ type: 'float' })
  priceKwdPerDay!: number;

  @Column()
  availability!: string;

  @Column({ type: 'float', default: 4.5 })
  rating!: number;

  @Column({ type: 'int', default: 0 })
  reviewCount!: number;

  @Column({ default: 'active' })
  status!: string;

  @CreateDateColumn()
  createdAt!: Date;
}
